/*
 * <one line to give the program's name and a brief idea of what it does.>
 * Copyright (C) 2021  <copyright holder> <email>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "notify.h"
#include <QtQuickTemplates2/private/qquickaction_p.h>
#include <KNotification>
#include <QPixmap>

Notify::Notify(QObject* parent) : QObject(parent)
,m_defaultAction(nullptr)
{
}

QQmlListProperty<QQuickAction> Notify::actions()
{
  return {this, this,
      &Notify::appendAction,
          &Notify::actionsCount,
          &Notify::action,
          &Notify::clearActions,
          &Notify::replaceAction,
          &Notify::removeLastAction
    };
}

void Notify::appendAction(QQuickAction* action)
{
  m_actions.append(action);
}

int Notify::actionsCount() const
{
  return m_actions.count();
}

QQuickAction * Notify::action(int index) const
{
  return m_actions.at(index);
}

void Notify::clearActions()
{
  m_actions.clear();
}

void Notify::replaceAction(int index, QQuickAction* action)
{
  m_actions[index] = action;
}

void Notify::removeLastAction()
{
  m_actions.removeLast();
}

void Notify::appendAction(QQmlListProperty<QQuickAction>* list, QQuickAction* action)
{
  reinterpret_cast< Notify* >(list->data)->appendAction(action);
}

int Notify::actionsCount(QQmlListProperty<QQuickAction>* list)
{
  return reinterpret_cast< Notify* >(list->data)->actionsCount();
}

QQuickAction * Notify::action(QQmlListProperty<QQuickAction>* list, int index)
{
  return reinterpret_cast< Notify* >(list->data)->action(index);
}

void Notify::clearActions(QQmlListProperty<QQuickAction>* list)
{
  reinterpret_cast< Notify* >(list->data)->clearActions();
}

void Notify::replaceAction(QQmlListProperty<QQuickAction>* list, int index, QQuickAction* action)
{
  reinterpret_cast< Notify* >(list->data)->replaceAction(index, action);
}

void Notify::removeLastAction(QQmlListProperty<QQuickAction>* list)
{
  reinterpret_cast< Notify* >(list->data)->removeLastAction();
}

void Notify::send()
{

  //const auto groups = contact->groups();
  //for (const QString &group : groups) {
  //    m_notification->addContext("group", group);
  //}


  auto notification = new KNotification(m_eventId);


  QStringList actionsLabels;
  for(const auto &action : qAsConst(m_actions))
    {
      actionsLabels << action->text ();
      qDebug() << "Setting notify actions first" << actionsLabels;
    }
  notification->setActions (actionsLabels);

  if(m_defaultAction)
    {
      notification->setDefaultAction (m_defaultAction->text ());
    }

  notification->setComponentName (m_componentName);
  notification->setText (m_message);
  notification->setTitle (m_title);
  notification->setIconName (m_iconName);
//  notification->setUrls (m_urls);

  qDebug() << notification->eventId ();
  //  connect(this, &Notify::imageSourceChanged, m_notification, [this](QUrl source)
  //  {
  //    m_notification->setPixmap (QPixmap(source.toString ()));
  //  });


  connect(notification, QOverload<unsigned int>::of(&KNotification::activated), this, &Notify::actionActivated);

  connect(notification, &KNotification::defaultActivated,[this]()
  {
      if(m_defaultAction)
        m_defaultAction->trigger (this);
    });

  notification->sendEvent();
}

const QString &Notify::componentName() const
{
  return m_componentName;
}

void Notify::setComponentName(const QString &newComponentName)
{
  if (m_componentName == newComponentName)
    return;
  m_componentName = newComponentName;
  emit componentNameChanged(m_componentName);
}

void Notify::actionActivated(int index)
{
  qDebug() << "notify action was activated at <<" << index;
if(index == 0)
{
      return;
  }

  if(index >= 1 && index-1 < m_actions.count ())
    {
      m_actions.at (index-1)->trigger ();
    }
}

const QString &Notify::eventId() const
{
  return m_eventId;
}

void Notify::setEventId(const QString &newEventId)
{
  m_eventId = newEventId;
}

const QString &Notify::title() const
{
  return m_title;
}

void Notify::setTitle(const QString &newTitle)
{
  if (m_title == newTitle)
    return;
  m_title = newTitle;
  emit titleChanged(m_title);
}

const QString &Notify::message() const
{
  return m_message;
}

void Notify::setMessage(const QString &newMessage)
{
  if (m_message == newMessage)
    return;
  m_message = newMessage;
  emit messageChanged(m_message);
}

const QString &Notify::iconName() const
{
  return m_iconName;
}

void Notify::setIconName(const QString &newIconName)
{
  if (m_iconName == newIconName)
    return;
  m_iconName = newIconName;
  emit iconNameChanged(m_iconName);
}

const QUrl &Notify::imageSource() const
{
  return m_imageSource;
}

void Notify::setImageSource(const QUrl &newImageSource)
{
  if (m_imageSource == newImageSource)
    return;
  m_imageSource = newImageSource;
  emit imageSourceChanged(m_imageSource);
}

QQuickAction *Notify::defaultAction() const
{
  return m_defaultAction;
}

void Notify::setDefaultAction(QQuickAction *newDefaultAction)
{
  if (m_defaultAction == newDefaultAction)
    return;
  m_defaultAction = newDefaultAction;
  emit defaulActionChanged();
}

const QList<QUrl> &Notify::urls() const
{
  return m_urls;
}

void Notify::setUrls(const QList<QUrl> &newUrls)
{
  if (m_urls == newUrls)
    return;
  m_urls = newUrls;
  emit urlsChanged(m_urls);
}

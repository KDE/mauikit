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
#include <KNotification>
#include <QPixmap>
#include <QDebug>

NotifyAction::NotifyAction(QObject* parent) : QObject(parent)
{
}

void NotifyAction::setText(const QString& text)
{
    if(text == m_text)
    {
        return;
    }
    
    m_text = text;
    Q_EMIT textChanged();
}

QString NotifyAction::text() const
{
    return m_text;
}

Notify::Notify(QObject* parent) : QObject(parent)
,m_defaultAction(nullptr)
{
}

QQmlListProperty<NotifyAction> Notify::actions()
{
 return { };
}

void Notify::appendAction(NotifyAction* action)
{
  m_actions.append(action);
}

int Notify::actionsCount() const
{
  return m_actions.count();
}

NotifyAction * Notify::action(int index) const
{
  return m_actions.at(index);
}

void Notify::clearActions()
{
  m_actions.clear();
}

void Notify::replaceAction(int index, NotifyAction* action)
{
  m_actions[index] = action;
}

void Notify::removeLastAction()
{
  m_actions.removeLast();
}

void Notify::appendAction(QQmlListProperty<NotifyAction>* list, NotifyAction* action)
{
  reinterpret_cast< Notify* >(list->data)->appendAction(action);
}

int Notify::actionsCount(QQmlListProperty<NotifyAction>* list)
{
  return reinterpret_cast< Notify* >(list->data)->actionsCount();
}

NotifyAction * Notify::action(QQmlListProperty<NotifyAction>* list, int index)
{
  return reinterpret_cast< Notify* >(list->data)->action(index);
}

void Notify::clearActions(QQmlListProperty<NotifyAction>* list)
{
  reinterpret_cast< Notify* >(list->data)->clearActions();
}

void Notify::replaceAction(QQmlListProperty<NotifyAction>* list, int index, NotifyAction* action)
{
  reinterpret_cast< Notify* >(list->data)->replaceAction(index, action);
}

void Notify::removeLastAction(QQmlListProperty<NotifyAction>* list)
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
  // for(const auto &action : qAsConst(m_actions))
  //   {
  //     actionsLabels << action->text ();
  //     qDebug() << "Setting notify actions first" << actionsLabels;
  //   }
  // notification->setActions (actionsLabels);
  // 
  // if(m_defaultAction)
  //   {
  //     notification->setDefaultAction (m_defaultAction->text ());
  //   }

  notification->setComponentName (m_componentName);
  notification->setText (m_message);
  notification->setTitle (m_title);
  notification->setIconName (m_iconName);
  notification->setPixmap (QPixmap(m_imageSource.toString()));  
 notification->setUrls (m_urls);

  qDebug() << notification->eventId ();
  

  // connect(notification, QOverload<unsigned int>::of(&KNotification::activated), this, &Notify::actionActivated);
  // 
  // connect(notification, &KNotification::defaultActivated,[this]()
  // {
  //     if(m_defaultAction)
  //      Q_EMIT m_defaultAction->triggered (this);
  //   });

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
  Q_EMIT componentNameChanged(m_componentName);
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
      Q_EMIT m_actions.at (index-1)->triggered (this);
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
  Q_EMIT titleChanged(m_title);
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
  Q_EMIT messageChanged(m_message);
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
  Q_EMIT iconNameChanged(m_iconName);
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
  Q_EMIT imageSourceChanged(m_imageSource);
}

NotifyAction *Notify::defaultAction() const
{
  return m_defaultAction;
}

void Notify::setDefaultAction(NotifyAction *newDefaultAction)
{
  if (m_defaultAction == newDefaultAction)
    return;
  m_defaultAction = newDefaultAction;
  Q_EMIT defaulActionChanged();
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
  Q_EMIT urlsChanged(m_urls);
}
